--冥王神祗之一天空龙
function c77240080.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240080.spcon)
    e1:SetOperation(c77240080.spop)
    c:RegisterEffect(e1)
	
    --抗性
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c77240080.efilter)
	c:RegisterEffect(e2)
	
    --equip
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77240080,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetRange(LOCATION_MZONE)    
    e3:SetCountLimit(1)
    e3:SetTarget(c77240080.eqtg)
    e3:SetOperation(c77240080.eqop)
    c:RegisterEffect(e3)
	
    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77240080,1))
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c77240080.target)
    e4:SetOperation(c77240080.activate)
    c:RegisterEffect(e4)	
end
--------------------------------------------------------------------
function c77240080.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,3,c)
end
function c77240080.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,3,3,c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
--------------------------------------------------------------------
function c77240080.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77240080.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77240080.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if c:IsFaceup() and c:IsRelateToEffect(e) then
            local atk=tc:GetAttack()
            if tc:IsFacedown() then atk=0 end
            if atk<0 then atk=0 end
            if not Duel.Equip(tp,tc,c,false) then return end
            e:SetLabelObject(tc)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c77240080.eqlimit)
            tc:RegisterEffect(e1)
            if atk>0 then
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_EQUIP)
                e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
                e2:SetCode(EFFECT_UPDATE_ATTACK)
                e2:SetReset(RESET_EVENT+0x1fe0000)
                e2:SetValue(atk)
                tc:RegisterEffect(e2)
            end
            if tc:IsFaceup() then
                local e3=Effect.CreateEffect(c)
                e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                e3:SetCode(EVENT_ADJUST)
                e3:SetRange(LOCATION_SZONE) 
                e3:SetOperation(c77240080.operation)
                e3:SetReset(RESET_EVENT+0x1fe0000)
                tc:RegisterEffect(e3)
            end
        else Duel.SendtoGrave(tc,REASON_EFFECT) end
    end
end
function c77240080.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local eq=e:GetHandler():GetEquipTarget()
    local code=c:GetOriginalCode()
    eq:CopyEffect(code,RESET_EVENT+0x1fe0000)
end
--------------------------------------------------------------------
function c77240080.filter(c)
    return c:IsFaceup()
end
function c77240080.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240080.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c77240080.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77240080.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local tg=g:GetMinGroup(Card.GetAttack)	
        if tg:GetCount()>1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_FACEUP)
            local sg=tg:Select(tp,1,1,nil)
            local dam=sg:GetFirst():GetAttack()
            Duel.Damage(1-tp,dam,REASON_EFFECT)
        else
            local dam=tg:GetFirst():GetAttack()		
		    Duel.Damage(1-tp,dam,REASON_EFFECT)
		end      
    end
end

function c77240080.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end