--Time Magic Hammer
local s,id=GetID()
function s.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCodeFun(c,71625222,282,1,true,true)

	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)
        
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(s.setcon)
    e1:SetOperation(s.set)
    c:RegisterEffect(e1)

     local e3=Effect.CreateEffect(c)
     e3:SetType(EFFECT_TYPE_SINGLE)
     e3:SetCode(EFFECT_EQUIP_LIMIT)
     e3:SetValue(s.eqlimit)
     c:RegisterEffect(e3)
end
s.listed_names={71625222,282}
s.roll_dice=true
s.counter_place_list={0x1087}

function s.filter2(c)
	return c:IsFaceup() 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and s.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function s.setcon(e,tp,eg,ep,ev,re,r,rp)
      return Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function s.set(e,tp,eg,ep,ev,re,rp)
	local et=e:GetHandler():GetEquipTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(1)
    e:GetHandler():RegisterEffect(e1)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e3:SetValue(1)
    e:GetHandler():RegisterEffect(e3)

    local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    if #g>0 then
        local tc=g:GetFirst()    
        while tc do
            local dice=Duel.TossDice(tp,1)
            tc:AddCounter(0x1087,dice)
            tc=g:GetNext()
        end
        --Future Swing
        local e5=Effect.CreateEffect(e:GetHandler()) 
        e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
        e5:SetCode(EVENT_PHASE+PHASE_STANDBY) 
        e5:SetCountLimit(1) 
        e5:SetRange(LOCATION_SZONE) 
        e5:SetCondition(s.con) 
        e5:SetOperation(s.act)
        e5:SetLabel(10)
        e5:SetReset(RESET_EVENT+RESETS_STANDARD)
        e:GetHandler():RegisterEffect(e5)     
    end
end

function s.eqlimit(e,c)
    return c:IsFaceup()
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function s.filter(c,rc,ct)
    return c:GetFlagEffect(170000195)>0 and c:GetFlagEffectLabel(170000195)==ct
end
function s.cfilter(c)
    return Duel.GetTurnCount()==c:GetTurnID()+c:GetFlagEffect(170000195)*2
end
function s.act(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()==10 then
        local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
		local tc=g2:GetFirst()
        while tc do
            local dice=tc:GetCounter(0x1087)
            tc:RegisterFlagEffect(170000195,RESET_EVENT+RESETS_REDIRECT-RESET_TEMP_REMOVE,0,1,dice)
            tc=g2:GetNext()
        end
        local maxct=0
		Duel.Remove(g2,nil,REASON_EFFECT+REASON_TEMPORARY)
        local rg=Duel.GetOperatedGroup()
        if #rg<1 then return end
        local tc=rg:GetFirst()
        while tc do
			local dice=tc:GetFlagEffectLabel(170000195)
            maxct=math.max(dice,maxct)
            tc=rg:GetNext()
        end
		e:SetLabel(0)
	elseif e:GetLabel()>=0 then  
 		c:SetTurnCounter(e:GetLabel()+1)
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,c,e:GetLabel()+1)
		if #g>0 then
			local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
			if #g>=ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local sg=g:Select(1-tp,ft,ft,nil)
				for tc in aux.Next(sg) do
					Duel.ReturnToField(tc)
					g:RemoveCard(tc)
				end
				Duel.SendtoGrave(g,REASON_RULE+REASON_RETURN)
			else
				for tc in aux.Next(g) do
					Duel.ReturnToField(tc)
				end
			end
		end
		e:SetLabel(e:GetLabel()+1)
		if e:GetLabel()>=6 then e:Reset() end
	end
end

function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
