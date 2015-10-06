
import org.apache.sling.event.jobs.JobProcessor;
import org.apache.sling.event.jobs.JobUtil;
 
import org.osgi.service.event.Event;
import org.osgi.service.event.EventHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
 
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
 
import com.adobe.granite.workflow.event.WorkflowEvent;
import com.adobe.granite.workflow.exec.WorkItem;
 
/**
 * The <code>WorkflowEventCatcher</code> class listens to workflow events. 
 */
@Component(metatype=false, immediate=true)
@Service(value=org.osgi.service.event.EventHandler.class)
public class WorkflowEventCatcher implements EventHandler, JobProcessor {
 
    @Property(value=com.adobe.granite.workflow.event.WorkflowEvent.EVENT_TOPIC)
    static final String EVENT_TOPICS = "event.topics";
 
    private static final Logger logger = LoggerFactory.getLogger(WorkflowEventCatcher.class);
 
    public void handleEvent(Event event) {
        JobUtil.processJob(event, this);
    }
 
    public boolean process(Event event) {
        logger.info("Received event of topic: " + event.getTopic());
        String topic = event.getTopic();
 
        try {
            if (topic.equals(WorkflowEvent.EVENT_TOPIC)) {
                WorkflowEvent wfevent = (WorkflowEvent)event;
                String eventType = wfevent.getEventType();
                String instanceId = wfevent.getWorkflowInstanceId();
 
                if (instanceId != null) {
                    //workflow instance events
                    if (eventType.equals(WorkflowEvent.WORKFLOW_STARTED_EVENT) ||
                            eventType.equals(WorkflowEvent.WORKFLOW_RESUMED_EVENT) ||
                            eventType.equals(WorkflowEvent.WORKFLOW_SUSPENDED_EVENT)) {
                        // your code comes here...
                    } else if (
                            eventType.equals(WorkflowEvent.WORKFLOW_ABORTED_EVENT) ||
                            eventType.equals(WorkflowEvent.WORKFLOW_COMPLETED_EVENT)) {
                        // your code comes here...
                    }
                    // workflow node event
                    if (eventType.equals(WorkflowEvent.NODE_TRANSITION_EVENT)) {
                        WorkItem currentItem = (WorkItem) event.getProperty(WorkflowEvent.WORK_ITEM);
                        // your code comes here...
                    }
                }
            }
        } catch(Exception e){
            logger.debug(e.getMessage());
            e.printStackTrace();
        }
        return true;
    }
}
