--血影
function c77239054.initial_effect(c)
	--攻击时猜硬币
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c77239054.attg)
	e1:SetOperation(c77239054.atop)
	c:RegisterEffect(e1)
	
    --装备
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCondition(c77239054.eqcon)
    e2:SetTarget(c77239054.eqtg)
    e2:SetOperation(c77239054.eqop)
    c:RegisterEffect(e2)	
end
----------------------------------------------------------
function c77239054.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c77239054.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local coin=Duel.SelectOption(tp,60,61)
		local res=Duel.TossCoin(tp,1)
		if coin~=res then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
------------------------------------------------------------
function c77239054.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    e:SetLabelObject(tc)
    return aux.bdogcon(e,tp,eg,ep,ev,re,r,rp)
end
function c77239054.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsHasEffect(77239054)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
    local tc=e:GetLabelObject()
    Duel.SetTargetCard(tc)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c77239054.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        local atk=tc:GetBaseAttack()
        if atk<0 then atk=0 end
        if not Duel.Equip(tp,tc,c,false) then return end
        --Add Equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c77239054.eqlimit)
        tc:RegisterEffect(e1)
        if atk>0 then
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_EQUIP)
            e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            e2:SetValue(300)
            tc:RegisterEffect(e2)
        end
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_EQUIP)
        e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetCode(6669251)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e3)
    end
end
function c77239054.eqlimit(e,c)
    return e:GetOwner()==c
end


