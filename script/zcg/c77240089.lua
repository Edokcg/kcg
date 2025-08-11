--切西亚的赠礼
function c77240089.initial_effect(c)
     --Damage
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_ACTIVATE)
	 e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	 e1:SetCode(EVENT_DAMAGE)
	 e1:SetCondition(c77240089.condition)
	 e1:SetOperation(c77240089.drop)
	 c:RegisterEffect(e1)
end

function c77240089.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c77240089.filter(c,e,tp)
    return c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240089.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(77240089,0),aux.Stringid(77240089,1))
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroupCount(c77240089.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if op==0 then
	if g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c77240089.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.Equip(tp,c,tc,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c77240089.eqlimit)
			e1:SetLabelObject(tc)
			c:RegisterEffect(e1)
				--destroy
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
				e2:SetCategory(CATEGORY_DESTROY)
				e2:SetCode(EVENT_BATTLE_CONFIRM)
				e2:SetRange(LOCATION_SZONE)
				e2:SetCondition(c77240089.descon)
				e2:SetTarget(c77240089.destg)
				e2:SetOperation(c77240089.desop)
				c:RegisterEffect(e2)
				--[[else
				c:CancelToGrave(false)]]
			end
		end
	end
	if op==1 then
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		--reduce
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetRange(LOCATION_SZONE)
		e3:SetTargetRange(1,1)
		e3:SetValue(c77240089.damval)
		c:RegisterEffect(e3)
		--[[local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		c:RegisterEffect(e4)]]
end
end
function c77240089.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetEquipTarget()
    local bc=c:GetBattleTarget()
    return bc and c:GetAttack()<=bc:GetAttack()
end
function c77240089.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local bc=e:GetHandler():GetEquipTarget():GetBattleTarget()
    Duel.SetTargetCard(bc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c77240089.desop(e,tp,eg,ep,ev,re,r,rp)
    local bc=Duel.GetFirstTarget()
    if bc:IsRelateToEffect(e) then
        Duel.Destroy(bc,REASON_EFFECT)
		Duel.Damage(1-tp,e:GetHandler():GetEquipTarget():GetAttack(),REASON_EFFECT)
    end
end
function c77240089.damval(e,re,val,r,rp,rc)
    return val*2
end

function c77240089.eqlimit(e,c)
	return c==e:GetLabelObject()
end